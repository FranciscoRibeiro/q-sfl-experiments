import os
import sys
import imp

load = lambda f: imp.load_source(f, 'scripts/{}.py'.format(f))

run_default_landmarks = load('run_default_landmarks')
run_classification_landmarks = load('run_classification_landmarks')
run_fault_locator = load('run_fault_locator')
run_diagnosis_native = load('run_diagnosis_native')

BASE_PATH="data"

def project_path(project, version, base=BASE_PATH):
    return "{}/{}/{}".format(base, project, version)

def run(project, version):
    path = project_path(project, version)

    #check if directory was created
    if os.path.isdir(path):
        run_default_landmarks.create_thresholds(project, version)
        run_classification_landmarks.create_thresholds(project, version)
        run_fault_locator.run_fault_locator(project, version)
        run_diagnosis_native.run_diagnosis(project, version)

if __name__ == "__main__":
    project = sys.argv[1]
    version = sys.argv[2]
    run(project, version)
