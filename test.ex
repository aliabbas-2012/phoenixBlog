# Create the POst. Note that the (empty) `organizations` field has to be preloaded.
alias BlogTest.Post
alias BlogTest.Category
alias BlogTest.Repo
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
changeset = post1 |> Repo.preload(:categories) |>  Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:categories, [category1,category2])
Repo.update!(changeset)
