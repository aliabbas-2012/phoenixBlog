# Create the POst. Note that the (empty) `organizations` field has to be preloaded.
alias BlogTest.Post
alias BlogTest.Category
alias BlogTest.Image
alias BlogTest.Repo
import Ecto.Query

post_params = %{title: "Post a 1",content: "Test content 21"}
changeset = Post.changeset(%BlogTest.Post{}, post_params)
|> Ecto.Changeset.put_change(:user_id,1)

post = Repo.insert!(changeset) |> Repo.preload(:categories)

# Do the same for the organization:
cats = %Category{name: "cat111"}
cats = Repo.insert!(cats) |> Repo.preload(:posts)

changeset = Ecto.Changeset.change(post) |> Ecto.Changeset.put_assoc(:categories, [cats])
Repo.update!(changeset)


#another example

post1 = Repo.get!(Post, 2)
category1 = Repo.get!(Category, 1)
category2 = Repo.get!(Category, 2)
changeset = post1 |> Repo.preload(:categories) |>  Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:categories, nil])
Repo.update!(changeset)



post.categories |> Enum.find(fn {key, val} -> key == 'name' end)

Enum.map(post.categories, fn {k, v} -> {v} end)

people = post.categories |> Enum.map(&[&1.name])



query = from p in Post, select: p.title
Repo.all(query)

posts = Repo.all from p in Post,
  order_by: [desc: p.updated_at],
  preload: [:user]

Enum.map(["1"],fn(x)-> String.to_integer(x) end)

categories = Enum.map(["1"],fn(x)-> String.to_integer(x) end)

from(p in Category, where: p.id in  ^categories) |> Repo.all
from(p in Category, where: p.id in  ^Enum.map([],fn(x)-> String.to_integer(x) end)) |> Repo.all

from(p in Category, where: p.id in [1] ) |> Repo.all


#How to find User by attribute name
Repo.get_by(User, email:  String.downcase("itsgeniusstar@gmail.com"))

#Auth Token

alias BlogTest.AuthorizeToken
Repo.get_by(AuthorizeToken, user_id:  1)
Repo.get_by(AuthorizeToken, user_id:  1, token: "2xw60hqAzLF7xiAVj8UUj_vw-cviete41491480714390")
