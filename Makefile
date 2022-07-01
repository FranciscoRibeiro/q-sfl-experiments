.PHONY: build build8 mvn-package

CONTAINER=qsfl
CONTAINERJDK8=qsfljdk8
DOCKERFILEJDK8=Dockerfile_jdk8
QSFL=https://github.com/FranciscoRibeiro/q-sfl.git
FLDATA=https://bitbucket.org/rjust/fault-localization-data.git
U_ID=$(shell id -u)
G_ID=$(shell id -g)

all: build build8 q-sfl fault-localization-data mvn-package

build: q-sfl
	docker build -t ${CONTAINER} \
		--build-arg USER_ID=${U_ID} \
		--build-arg GROUP_ID=${G_ID} .

build8: q-sfl
	docker build -f ${DOCKERFILEJDK8} -t ${CONTAINERJDK8} \
		--build-arg USER_ID=${U_ID} \
		--build-arg GROUP_ID=${G_ID} .

q-sfl:
	git clone ${QSFL} q-sfl

fault-localization-data:
	git clone ${FLDATA} fault-localization-data

mvn-package: q-sfl
	cd q-sfl && mvn package
