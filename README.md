# supibot-sql
Legacy SQL code definitions previously used in the [Supibot](https://github.com/Supinic/supibot) project.

Originally, it seemed like a good idea to have definitions stored in the database. However, that had absolutely no version control, and working with other collaborators was nigh-impossible. This repository was then created along with several "hack" scripts that would pull, or push changes from the Supibot database to the repo. There was no automation and it had to be run manually every time, sometimes losing changes or breaking completely.

This repository has therefore been replaced by the [supibot-package-manager](https://github.com/Supinic/supibot-package-manager) repository - using a modular approach to commands, crons, and other modules.
