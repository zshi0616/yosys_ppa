import os 
import subprocess
import shlex
import time
import shutil
import glob 

def run_command(command, timeout=-1):
    try: 
        command_list = shlex.split(command)
        process = subprocess.Popen(command_list, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        start_time = time.time()
        while process.poll() is None:
            if timeout > 0 and time.time() - start_time > timeout:
                process.terminate()
                process.wait()
                raise TimeoutError(f"Command '{command}' timed out after {timeout} seconds")

            time.sleep(0.1)

        stdout, stderr = process.communicate()
        if len(stderr) > len(stdout):
            return str(stderr).split('\\n'), time.time() - start_time
        else:
            return str(stdout).split('\\n'), time.time() - start_time
    except TimeoutError as e:
        return e, -1

def report_ppa(verilog_path):
    if not os.path.exists('./tmp'):
        os.makedirs('./tmp')
    shutil.copy(verilog_path, './tmp/rtl.v')
    
    # Yosys
    if not os.path.exists('./tmp/rtl.v'):
        return -1, -1
        # raise FileNotFoundError(f"Verilog file {verilog_path} not found")
    yosys_cmd = 'yosys ./script/mapping.ys'
    yosys_out, _ = run_command(yosys_cmd)
    
    # ABC
    if not os.path.exists('./tmp/pm.v'):
        return -1, -1
        # raise FileNotFoundError(f"Mapping file not found")
    abc_cmd = 'yosys-abc -c "source script/sta.tcl"'
    abc_out, _ = run_command(abc_cmd)
    
    # Parse
    area = -1
    delay = -1
    for line in abc_out:
        if 'Area' in line and 'Delay' in line:
            arr = line.split('\\x1b')
            for ele in arr:
                if 'Area' in ele:
                    ele_str = ele.replace(' ', '').split('=')[-1]
                    area = float(ele_str)
                elif 'Delay' in ele:
                    ele_str = ele.replace(' ', '').split('=')[-1]
                    ele_str = ele_str.replace('ps', '')
                    delay = float(ele_str)
    os.remove('./tmp/rtl.v')
    os.remove('./tmp/pm.v')

    return area, delay
    

if __name__ == '__main__':
    for v_path in glob.glob('./problem_case/*/*.v'):
        if '15456_rewritten' not in v_path:
            continue
        print('RTL path:', v_path)
        area, delay = report_ppa(v_path)
        print('Area: {:.2f}, Delay: {:.2f} ps'.format(area, delay))        
        print()