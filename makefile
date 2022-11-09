# Combined makefile to build both thesis and proposal from the repository root.
# Works by calling the individual makefiles from their own directories.
all:
	$(MAKE) -C latex/

clean:
	$(MAKE) -C latex/ clean

delete:
	$(MAKE) -C latex/ delete