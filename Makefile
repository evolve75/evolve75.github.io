.PHONY: help init serve build clean new-post update-theme

help:
	@echo "Targets:"
	@echo "  init          Init/update the PaperMod theme submodule"
	@echo "  serve         Run the local Hugo dev server (with drafts)"
	@echo "  build         Build the site into ./public (same flags as CI)"
	@echo "  clean         Remove build output"
	@echo "  new-post NAME=slug   Scaffold a new post at content/blog/<slug>.md"
	@echo "  update-theme  Pull the latest PaperMod theme commit"

init:
	git submodule update --init --recursive

serve: init
	hugo server -D

build: init
	hugo build --gc --minify --baseURL "https://www.anupamsg.me/"

clean:
	rm -rf public resources .hugo_build.lock

new-post: init
	@if [ -z "$(NAME)" ]; then echo "Usage: make new-post NAME=my-post-slug"; exit 1; fi
	hugo new content blog/$(NAME).md

update-theme: init
	git submodule update --remote --merge themes/PaperMod
