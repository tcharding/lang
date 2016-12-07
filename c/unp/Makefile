# Attribution: Andrew Cooks (acooks@gmail.com)
SUBDIRS = daytimetcp lib
CLEANDIRS = $(SUBDIRS:%=clean-%)

.PHONY: all $(SUBDIRS)

all: $(SUBDIRS)
	@echo "Done."

$(SUBDIRS): %:
	@echo "Making $@"
	@$(MAKE) --silent -C $@

clean: $(CLEANDIRS)
$(CLEANDIRS):
	@echo "Cleaning $@"
	@$(MAKE) --silent -C $(@:clean-%=%) clean
