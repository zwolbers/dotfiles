home:
	# --adopt and --restow seem to conflict; call stow twice
	stow --no-folding --target=$(HOME) --adopt home
	stow --no-folding --target=$(HOME) --restow home


clean:
	stow --no-folding --target=$(HOME) --delete home


.PHONY: default home clean

