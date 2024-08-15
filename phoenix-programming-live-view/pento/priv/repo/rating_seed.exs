import Ecto.Query
alias Pento.Accounts.User
alias Pento.Catalog.Product
alias Pento.{Repo, Accounts, Survey}

for i <- 65..93 do
  Accounts.register_user(%{
    email: "user#{i}@example.com",
    password: "my super strong password#{i}"
  }) |> IO.inspect
end

user_ids = Repo.all(from u in User, select: u.id, where: u.id > 24)
product_ids = Repo.all(from p in Product, select: p.id)
genders = ["female", "male", "other", "prefer not to say"]
years = 1999..2017
stars = 1..5

for uid <- user_ids do
  IO.puts("creating demo")
  Survey.create_demographic(%{
    user_id: uid,
    gender: Enum.random(genders),
    year_of_birth: Enum.random(years),
    education: Enum.random(["high school", "bachelor's degree", "graduate degree", "other"])
  })

end

for uid <- user_ids, pid <- product_ids do
 Survey.create_rating(%{
   user_id: uid,
   product_id: pid,
   stars: Enum.random(stars)

 })
end

