Treeprit.Code.load_scripts("repo/seeds")

Treeprit.new()
|> Treeprit.run(:role, Treeprit.Repo.Seeds.Role)
|> Treeprit.run(:user, Treeprit.Repo.Seeds.User)
|> Treeprit.finally()
