# Variables

MAINTAINERNAME=`cat settings.conf | grep MAINTAINERNAME | grep -oe '[a-z]\+'`
IMAGENAME=`cat settings.conf | grep IMAGENAME | grep -oe '[a-z]\+'`
MAILHOSTNAME=`cat settings.conf | grep MAILHOSTNAME | grep -oe '[a-z\.\-]\+'`

# Assignments

all: build

build:
	docker build -t $(MAINTAINERNAME)/$(IMAGENAME) .

run:
	-docker stop $(IMAGENAME)_ins
	-docker rm $(IMAGENAME)_ins
	docker run -h $(MAILHOSTNAME) --name $(IMAGENAME)_ins -p 3306:3306 -p 587:587 -p 143:143 -p 25:25 -p 80:80 -d $(MAINTAINERNAME)/$(IMAGENAME)
