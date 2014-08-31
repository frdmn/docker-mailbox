# Variables

CONTAINERNAME=`cat settings.conf | grep CONTAINERNAME | grep -oe '[a-z]\+'`
MAILHOSTNAME=`cat settings.conf | grep MAILHOSTNAME | grep -oe '[a-z\.\-]\+'`

# Assignments

all: build

build:
	docker build -t $(MAINTAINERNAME)/$(IMAGENAME) .

run:
	docker run -h $(MAILHOSTNAME) -d $(MAINTAINERNAME)/$(IMAGENAME)

run-attached:
	docker run -h $(MAILHOSTNAME) -t -i $(MAINTAINERNAME)/$(IMAGENAME)