# This script can be used to build/simulate a verification enviroment using Vivado TCL console.
# Usage:
#       1) Build: python VivadoCompile.py --mode build --project_dir <path_to_project_dir>
#       2) Sim: python VivadoCompile.py --mode sim --project_dir <path_to_project_dir>

import os
import glob
import subprocess
import argparse
import random
import shutil
import PrjFileBuilder

VIVADO_VERSION = "2023.1"


# Function used to extract the list of design/testbnech files from the path specified in --project_dir.
def extract_list_of_files(project_dir):
    # Find design files recursively

    extensions = ['*.sv', '*.svh', '*.v', '*.vh']
    design_files = []
    testbench_files = []

    for extension in extensions:
        design_pattern = f"{project_dir}/rtl/**/{extension}"
        testbench_pattern = f"{project_dir}/tb/**/{extension}"

        design_files.extend(glob.glob(design_pattern, recursive=True))
        testbench_files.extend(glob.glob(testbench_pattern, recursive=True))

    print('Design files:')
    print('\n'.join(design_files))

    print('\nTestbench files:')
    print('\n'.join(testbench_files))

    return [design_files,testbench_files]

# "work" dir will be created in the path mention in --project_dir
# structure of the "work" dir:
# --PROJECT_DIR
#   |- work
#      |- src - Directory containg the source file and other potential generated files
#      |- xsim - Direcotry containg the simulation executable. This dir is created by Vivado

def build_work_directory(project_dir, design_files, tb_files):

    build_dir = project_dir + "/work"
    src_dir = build_dir + "/src"

    #create "work" dir
    if not os.path.exists(build_dir):
        os.mkdir(build_dir)

    os.chdir(build_dir)

    # create "src" dir
    if not os.path.exists(src_dir):
        os.mkdir(src_dir)

    for i in range(len(design_files)):
        design_file = design_files[i]
        shutil.copy(design_file, src_dir)
        design_files[i] = src_dir + "/" + os.path.basename(design_file)

    for i in range(len(tb_files)):
        tb_file = tb_files[i]
        shutil.copy(tb_file, src_dir)
        tb_files[i] = src_dir + "/" + os.path.basename(tb_file)

    return [design_files, tb_files, build_dir]

# This functions creates the TCL script to build the design and testbench.
def create_build_tcl_script(tcl_script_file, prj_file, top_module):

    prj_file_tcl = prj_file.replace("\\", "\\\\")
    # Create a TCL script
    tcl_script = f"""

        # Create a library
        set prj_file "{prj_file_tcl}"
        set library_name "work"
        set top_module "{top_module}"
        set suffix_snapshot "_behav"
        set prefix_module_path "xil_defaultlib."
        set snapshotname $top_module$suffix_snapshot
        set topModulePath $prefix_module_path$top_module


        # Compile design testbench files
        puts "Executing: xvlog --incr --relax -L uvm -prj $prj_file -log xvlog.log"
        if {{[catch {{exec xvlog --incr --relax -L uvm -prj $prj_file -log xvlog.log}} resultVar]}} {{
            puts "Error occurred during compilation: $resultVar"
            exit
        }} else {{
        # Elaborate the library
            puts "Executing: xelab --incr --debug typical --relax --mt 2 -L xil_defaultlib -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot $snapshotname $topModulePath -log xelab.log"
            if {{[catch {{exec xelab --incr --debug typical --relax --mt 2 -L xil_defaultlib -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot $snapshotname $topModulePath -log xelab.log }} resultVar]}} {{
                puts "Error occurred during elaboration: $resultVar"
                exit
            }} else {{
                # Exit the program
                exit
            }}
        }}
    """

    # Write the TCL script to a file
    with open(tcl_script_file, "w") as f:
        f.write(tcl_script)

# Build the design and the verification enviroment, in vivado tcl console.
# Create the TCL simulation script by calling create_tcl_script_and_sim_command.
def build(prj_file, top_module):

    #top_module = input('Please the name of the top module:\n');

    print ("Project file: " + prj_file)

    tcl_script_file = "build.tcl"
    create_build_tcl_script(tcl_script_file, prj_file, top_module)

    print("Starting to run the TCL compile script...")
    # Run the TCL script in Vivado and capture the output
    process = subprocess.Popen(
        ["C:/Xilinx/Vivado/" + VIVADO_VERSION +"/bin/vivado.bat", "-mode", "tcl", "-source", tcl_script_file],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )


    # Print the output to the console
    for line in process.stdout:
        print(line, end='')

    for line in process.stderr:
        print(line, end='')

    # Wait for the process to complete
    process.wait()

    create_tcl_script_and_sim_command(top_module)


# Create simmulation command which is saved in build/sim_command file .
# Create the TCL script used for waveform configuration in build/waveconfig.tcl.
def create_tcl_script_and_sim_command(top_module):

    tcl_script = """
    log_wave -recursive *
  run all
  exit
    """

    # Save the Tcl script to a file
    with open("waveconfig.tcl", "w") as file:
        file.write(tcl_script)

    sim_command = ["C:/Xilinx/Vivado/" + VIVADO_VERSION +"/bin/xsim.bat",
                   top_module + "_behav",
                   "-key",
                   "Behavioral:sim_1:Functional:" + top_module,
                   "-log",
                   "sim.log",
                   "-tclbatch",
                   "waveconfig.tcl"]

    with open("sim_cmd_template", "w") as file:
        for arg in sim_command:
            print(arg, file=file)

# Launch the sim command stored in build/sim_command
def simulate(project_dir, sim_opts, sim_dir):

    timeout_seconds = 300  # Adjust the timeout duration as needed

    build_dir = project_dir + "/work"


    if not os.path.exists(build_dir):
        print("The mentioned build directory doesn't exists")
        return

    os.chdir(build_dir)
    sim_command = build_dir + "/sim_cmd_template"

    if not os.path.exists(sim_dir):
        os.mkdir(sim_dir)

    #recreate the simulation command from sim_command file generated in the build step
    with open(sim_command, "r") as f:
        sim_command = f.readlines()
        sim_command = [arg.rstrip('\n') for arg in sim_command]

    for i in range(len(sim_command)):
        if "sim.log" in sim_command[i]:
            sim_command[i] = sim_dir + "/" + sim_command[i]
            print (sim_command[i])

   #iterate the over the sim_args and add
    for arg in sim_opts:
        arg = arg.replace("+","")
        sim_command.append('--testplusarg')
        sim_command.append('"' + arg + '"')

    #generate seed
    random_seed = '"' + str(random.randint(0, 99999999999)) + '"'
    sim_command.append('--sv_seed')
    sim_command.append(random_seed)

    #generate waveforms
    sim_command.append("--wdb")
    sim_command.append(sim_dir + "/waveforms.wdb")


    with open(sim_dir + "/sim_cmd", "w") as file:
        for arg in sim_command:
            print(arg, file=file)

    # Run the TCL script in Vivado and capture the output
    process = subprocess.run(
        sim_command,
        check=True,
        timeout=timeout_seconds,
        text=True,
    )

    print("Finished the execution of TCL simulation script.")

# Check the return code
    if process.returncode != 0:
        # Error occurred, handle it
        print(f"Error occurred: {process.stderr.read()}")
    else:
    # Process completed successfully
        print("Process completed successfully.")

#this function is used to reuse a sim_command
def rerun_sim(project_dir, sim_command, sim_dir):

    timeout_seconds = 300  # Adjust the timeout duration as needed

    #recreate the simulation command from sim_command file generated in the build step
    os.chdir(project_dir + "/work")

    with open(sim_command, "r") as f:
        sim_command = f.readlines()
        sim_command = [arg.rstrip('\n') for arg in sim_command]

    for i in range(len(sim_command)):
        if "sim.log" in sim_command[i]:
            sim_command[i] = sim_dir + "/sim.log"
            print (sim_command[i])

    if not os.path.exists(sim_dir):
        os.mkdir(sim_dir)

    print("Sim dir" + sim_dir)

    #generate waveforms
    sim_command.append("--wdb")
    sim_command.append(sim_dir + "/waveforms.wdb")

    with open(sim_dir + "/sim_cmd", "w") as file:
        for arg in sim_command:
            print(arg, file=file)


    # Run the TCL script in Vivado and capture the output
    process = subprocess.run(
        sim_command,
        check=True,
        timeout=timeout_seconds,
        text=True,
    )


# Description for --help switch
parser = argparse.ArgumentParser(description=
    "This script can be used to build/simulate a verification environment using Vivado TCL console.")

# Parse command-line arguments
parser.add_argument("--mode", required=True, help = "Select the operating mode:\n --mode build - build design ; --mode sim  - start simulation");
parser.add_argument("--project_dir", required = True, help="Directory path containing design and testbench files")
parser.add_argument("--sim_opts", help="Provide simulation plusargs.")
parser.add_argument("--sim_dir", help="Provide a name for simulation directory. If not provided the sim dir will be named using the default name (sim_dir).")
parser.add_argument("--sim_cmd", help="Provide a path to a simulation command, to re-launch that simulation.")

args = parser.parse_args()

if args.mode == "build":

   if not args.project_dir:
    raise ValueError("Incomplete argument list. In build-mode (--mode 0) you need to specify --design_dir, -testbench_dir and the --prj_name (project.name)" )

   [design_files, tb_files] = extract_list_of_files(args.project_dir)
   [design_files, tb_files, build_dir] = build_work_directory(args.project_dir, design_files, tb_files)

   #print("After extraction" + str(file_list))
   if os.path.exists(build_dir + "/xsim.dir"):
    shutil.rmtree(build_dir + "/xsim.dir")

   prj_file = build_dir + "/build.prj"

   print("")

   top_module = PrjFileBuilder.generate_prj_file(design_files, tb_files, prj_file)

   build(prj_file, top_module)

elif args.mode == "sim":

    sim_dir = args.project_dir + "/work"
    sim_dir += "/sim_dir" if not args.sim_dir else ("/" + args.sim_dir)

    if os.path.exists(sim_dir):
        i = 1
        while os.path.exists(sim_dir + "_" + str(i)):
            i += 1
        sim_dir = sim_dir + "_" + str(i)

    sim_opts = "" if not args.sim_opts else args.sim_opts.split()

    if args.sim_cmd:
        rerun_sim(args.project_dir, args.sim_cmd, sim_dir)
    else:
        simulate(args.project_dir, sim_opts, sim_dir)