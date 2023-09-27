#import VivadoCompile
import os
import yaml
import argparse
import threading
import subprocess
import time
import signal

MAX_SIMS = 4
vivado_compile = "D:/Scripts/VivadoCompile.py"


def signal_handler(sig, frame):

    # Handle the Ctrl+C signal
    print("Ctrl+C (KeyboardInterrupt) detected. Exiting...")
    exit(0)
    
               
class MonitorThread(threading.Thread):
    def __init__(self, threads):
        super().__init__()
        self.threads = threads
        self.dispatcher = None
        
    def run(self):
        
        print("Monitoring in progress...")
        total_sims = len(self.threads)
        
        completed_sims = 0
    
        cnt_sims_running = 0
        running_sims_list = [] 
        
        
        i = 0
        
        while i < len(self.threads) or len(running_sims_list) != 0:
            if len(running_sims_list) < MAX_SIMS and i < len(self.threads):
                self.threads[i].start()
                cnt_sims_running += 1
                running_sims_list.append(self.threads[i])
                i += 1
                time.sleep(2)
                
                print( "Running sims: " + str(len(running_sims_list) ) )
                print( "Pending sims: " + str(len(self.threads) - i))
                print( "Finished sims: " + str(completed_sims) )
                print( "Total sims: " + str(total_sims) )
                print("")
            else:   
                for sim in running_sims_list:
                    if sim.is_completed:
                        sim.join()
                        running_sims_list.remove(sim)
                        completed_sims += 1
            
            
                print( "Running sims: " + str(len(running_sims_list) ) )
                print( "Pending sims: " + str(len(self.threads) - i))
                print( "Finished sims: " + str(completed_sims) )
                print( "Total sims: " + str(total_sims) )
                print("")
            
                time.sleep(10)
            
        print( "Finished sims: " + str(completed_sims) )
        print( "Total sims: " + str(total_sims) )
        print("")

class SimThread(threading.Thread):

    def __init__(self, thread_id, name):
        super().__init__()
        self.thread_id = thread_id
        self.name = name
        
        self.vivado_script = vivado_compile
        self.arg_list = []
        self.exit_status = 0
        self.is_running = 0
        self.is_completed = 0
    
    def run_script(self):
        devnull = open(os.devnull, 'w')
       
        try:
            self.is_running = 1 
            subprocess.run(["python", self.vivado_script] + self.arg_list, stdout=devnull, check=True)
        except subprocess.CalledProcessError as e:
            print(f"An error occurred while launching the script: {e}")
            self.is_running = 0
            self.is_completed = 1
        except FileNotFoundError:
            print("The script file was not found.")
            self.is_running = 0
            self.is_completed = 1
            
            
        self.is_running = 0
        self.is_completed = 1
    
    def run(self):
        #print("Started sim_id:  " + str(self.thread_id))
        self.run_script()
        #print("Endded sim_id:  " + str(self.thread_id))



signal.signal(signal.SIGINT, signal_handler)
   
# Description for --help switch
parser = argparse.ArgumentParser(description= "This script can be used to launch multiple sims at once. By default the sim launches 4 sims at the same time.")

parser.add_argument("--testlist", required=True, help = "");
parser.add_argument("--project_dir", required = True, help="Directory path containing design and testbench files")
parser.add_argument("--max_sims", help="Specify the maximum number of sims that can be dispatched at the same time.")

args = parser.parse_args()

if args.max_sims:
        MAX_SIMS = int(args.max_sims)


testlist = args.testlist
build_dir = args.project_dir + "/work"

os.chdir(build_dir)

try:
    with open(testlist, "r") as file:
        yaml_data = file.read()
        data = yaml.safe_load(yaml_data)
except FileNotFoundError:
    print("YAML file not found.")
    exit(1)
except yaml.YAMLError as e:
    print("Error while parsing the YAML file:")
    print(e)
    exit(1)
 
sims = [] 
sim_id = 0 
regr_dir = "regr"

if os.path.exists(regr_dir):
    i = 1
    while os.path.exists(regr_dir + "_" + str(i)):
        i += 1
    regr_dir = regr_dir + "_" + str(i)

os.mkdir(regr_dir)

for item in data:
    name = regr_dir + "/" +item["name"]
    description = item["description"]
    number = item["number"]
    switches = item["switches"]
    
    vivado_compile = "D:/Scripts/VivadoCompile.py" 
    script_arguments = "--mode sim --project_dir " + args.project_dir + " --sim_opts " + switches + " --sim_dir " + name 
    script_arguments = script_arguments.split()
    for i in range(0,number):
        sim = SimThread(sim_id, name)
        sim.arg_list = script_arguments
        sims.append(sim)
        sim_id += 1


monitor = MonitorThread(sims)

print("Monitor started....")
print("Simulations will start soon...")
 
monitor.start()
monitor.join()
    