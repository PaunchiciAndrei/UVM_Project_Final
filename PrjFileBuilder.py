# This module is used by VivadoCompile.py to build a dependecy tree based on the file includes

import os
import re
from collections import OrderedDict

# function for adding edge to graphdependencyTree = collections.OrderedDict()
tbDependencyTree  = OrderedDict()
rtlDependencyTree = OrderedDict()
pkgDependencyTree = OrderedDict()


pkg_files_to_print = []
rtl_files_to_print = []
tb_files_to_print = []

def addEdge(dependencyTree, u, v):
    if u not in dependencyTree:
        dependencyTree[u] = []
    dependencyTree[u].append(v)

#return the included file with the full path
def get_file_path(file_paths, included_file, has_pkg):

    if has_pkg :
        match = re.search(r'import\s+([^;]+)::', included_file)
    else:
        match = re.search(r'`include\s+"(.+)"', included_file)

    if match:
        filename = match.group(1)
        for file_path in file_paths:
            if filename in file_path:
                return file_path
    else:
        print("No match found for the following include statement " + included_file)

    return None

# commented the code of this function because is no longer needed
#def build_rtlDependencyTree(design_files):
    #parse design files to find dependecies
#    pattern = r'\b(\w+)\s+(\w+)\s*\(([^)]*)\)'
#
#    for design_file in design_files:
#        with open(design_file, 'r') as file:
#            source_code = file.read()

#        module_instantiations = re.findall(pattern, source_code)
#        module_names = [instantiation[0] for instantiation in module_instantiations]

        #search through design files and see if a design file contains the module name.
#        for module_name  in module_names:
#            for file_path in design_files:
#                if module_name in file_path:
#                    addEdge(rtlDependencyTree, design_file, file_path)

def build_tbDependencyTree(file_paths, tree, has_pkg):
    #parse testbench files to find dependecies
    if has_pkg :
        pattern = "import "
    else:
        pattern = "`include "

    for file_path in file_paths:
        with open (file_path, "r") as f:
            includes = [line for line in f if pattern in line]
            for include in includes:
                included_file = get_file_path(file_paths, include, has_pkg)
                if included_file is not None:
                    addEdge(tree, file_path, included_file)

def find_dependency_tree_head(dependencyTree):
    all_nodes = set(dependencyTree.keys())
    child_nodes = set(sum(dependencyTree.values(),[]))
    head_node = all_nodes - child_nodes
    for node in head_node:
        if node not in child_nodes:
            return node
    raise ValueError("No head node found")

#add new line in .prj string
def add_new_line(file_path, printed_files):
    line = "\"" + str(file_path) + "\" \\"
    if line not in printed_files:
        printed_files.append(line)


def iterate_node(node, dependencyTree, printed_files):

    for file_path in list(dependencyTree[node]):
        add_new_line(file_path, printed_files)
        if dependencyTree.get(file_path) is not None:
            iterate_node(file_path, dependencyTree, printed_files)

def get_top_module_name(head_node):
    file_name  = os.path.basename(str(head_node))
    file_extension  = os.path.splitext(str(head_node))[1]
    return file_name[:-len(file_extension)]

def generate_prj_file(design_files, testbench_files, prj_file):

    pkg_files = [file for file in testbench_files if "pkg" in file or "package" in file]
    if_files = [file for file in testbench_files if "_if" in file]

    #create .prj file
    file_path = os.path.abspath(prj_file)
    if os.path.exists(file_path):
        try:
            os.remove(prj_file)
            print(f"File '{file_path}' has been successfully removed.")
        except OSError as e:
            print(f"Error occurred while removing the file '{file_path}': {e}")


    #build TB dependecy tree and find the top module
    has_pkg = 0
    if len(pkg_files) > 0:
        has_pkg = 1
        for file in if_files:
            testbench_files.remove(file)

    build_tbDependencyTree(testbench_files, tbDependencyTree, has_pkg)
    top = find_dependency_tree_head(tbDependencyTree)
    top_module_name =  get_top_module_name(top)

    iterate_node(top, tbDependencyTree, tb_files_to_print)

    #build pkg dependecy tree and find the top module
    if len(pkg_files) > 0:
        build_tbDependencyTree(pkg_files, pkgDependencyTree, has_pkg)
        top_pkg = find_dependency_tree_head(pkgDependencyTree)
        iterate_node(top_pkg, pkgDependencyTree, pkg_files_to_print)

    with open(prj_file, 'w') as file:

        prj_header = "sv xil_defaultlib \\"
        print(prj_header, file=file)
        for file_path in design_files:
            line = "\"" + str(file_path) + "\" \\"
            print(line, file=file)

        if has_pkg:
            #print pkg_files
            for file_path in pkg_files_to_print:
                print(file_path, file=file)

            #print top_pkg
            line = "\"" + str(top_pkg) + "\" \\"
            print(str(line), file=file)

            #print interfaces
            for if_file in if_files:
                line = "\"" + str(if_file) + "\" \\"
                print(line, file=file)

        #print top module
        line = "\"" + str(top) + "\" \\"
        print(str(line), file=file)

        if not has_pkg:
            for tb_file in tb_files_to_print:
                print(tb_file, file=file)

    return top_module_name