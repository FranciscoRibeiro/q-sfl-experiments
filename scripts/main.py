import os
import sys
import subprocess

BASE_PATH="data"

def project_path(project, version, base=BASE_PATH):
    return "{}/{}/{}".format(base, project, version)

def call(command, timeout=None):
    print(command)
    try:
        return subprocess.call(command.split(' '),timeout=timeout)
    except subprocess.TimeoutExpired:
        return 124

def run(project, version):
    path = project_path(project, version)
    pwd = os.getcwd()
    home_dir = os.path.expanduser("~") #retrieves home directory; assumes maven is installed, i.e. $HOME/.m2 exists
    image = "qsfljdk8" if project == "Mockito" else "qsfl"
    #run docker command
    cmd = "docker run -i -v {}/.m2:/var/maven/.m2 -v {}/data:/data -e MAVEN_CONFIG=/var/maven/.m2 {} python3 run_experiment.py {} {}"\
            .format(home_dir, pwd, image, project, version)
    exit_code = call(cmd, timeout=10*60)
    if(exit_code == 124):
        exit(124)

if __name__ == "__main__":
    project = sys.argv[1]
    version = sys.argv[2]
    run(project, version)
