# Variables

CONTAINERNAME=`cat settings.conf | grep CONTAINERNAME | grep -oe '[a-z]\+'`
MAILHOSTNAME=`cat settings.conf | grep MAILHOSTNAME | grep -oe '[a-z\.\-]\+'`

# Assignments

all: build

build:
	docker build -t $(CONTAINERNAME) .

run:
	docker run -h $(MAILHOSTNAME) $(CONTAINERNAME)

run-interactive:
	docker run -h $(MAILHOSTNAME) -i -t $(CONTAINERNAME)
