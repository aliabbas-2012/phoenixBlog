# Create the POst. Note that the (empty) `organizations` field has to be preloaded.
alias BlogTest.User
alias BlogTest.AuthorizeToken
alias BlogTest.Post
alias BlogTest.Category
alias BlogTest.Image
alias BlogTest.Room
alias BlogTest.Message
alias BlogTest.Notification
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



#conditional and limit based relationship (has many )
user = Repo.get!(User, 1) |>  Repo.preload(images: from(c in Image, order_by: c.id, limit: 1))
user = Repo.get!(User, 1) |>  Repo.preload(:images)

#getting nested level records
Repo.all(from u in User, preload: [{:posts,
                                    [{:comments,:user},:likes]},
                                   :drafts])
# e.g messages
id  = 9
room = Repo.one(from room in Room,
   where: room.id == ^id,
   preload: [{:messages,[{:user,[:images]}]}])

room = Repo.one(from room in Room,
      where: room.id == ^id,
      preload: [{:messages,[{:user,[:images]}]}]
    )

room = Repo.one(from room in Room,
     where: room.id == ^id,
     preload: [{:messages,[{:user,[ {images: from(c in Image, order_by: c.id, limit: 1) } ]}]}]
   )

user = Repo.get!(User, 1) |>  Repo.preload(images: from(c in Image, order_by: c.id, limit: 1))


modela = Repo.one(from room in Room,  where: room.id == ^id )
         |> Repo.preload(:messages)
         |> Repo.preload(messages: :user)
         |> Repo.preload(user: :images)

 room = Repo.one(from room in Room,
      join: c in assoc(p, :messages),
      where: room.id == ^id,
      preload: [messages: c]
    )



case Repo.get_by(AuthorizeToken, token:  auth_token) |> Repo.preload(:user)  do
  nil ->
     :error
  auth ->
    IO.puts "---verifying token---"
    IO.inspect auth

end

auth_token = "SFMyNTY.g3QAAAACZAAEZGF0YWEBZAAGc2lnbmVkbgYAa3gQZlsB.V5jfbZvn9TnH4uEQBKs6o-N1lwgitfA2mBbFsvvmZe8"
auth_token = ""
auth = Repo.one(from authorize in AuthorizeToken,
   where: authorize.token == ^auth_token
)  |>  Repo.preload(user: from(c in User))



room = Repo.one(from room in Room,
   where: room.user_id == 1,
   where: or room.user_id_2 == 2
   )

   room = Repo.one(from room in Room,
      where: (room.user_id == 1 and room.user_id_2 == 3) or (room.user_id == 3 and room.user_id_2 == 1)
    )


posts = Post |> where([p], p.id in [1, 2]) |> Repo.all


notifications = Repo.all(from n in Notification,
     join: m in Message, on: n.id == m.message_id,
     where: n.is_seen == false,
     preload: [message: m]
   )

#Right but will get all
notifications = Repo.all(from [n,m] in Notification,Message
      join: m in Message, on: m.id == n.message_id,
      # select: (%{room_id: m.room_id, content: m.content,id: n.id}),
      where: (n.is_seen == false and m.room_id == 8),
      order_by: [desc: n.inserted_at],
      preload: [message: m],

)
#wrong ----------
notifications = Repo.all(
  from [p,m] in Notification, join: m in Message, on: m.id == p.message_id, preload: [message: m],
  select: %{id: p.id, content: m.content}
)

#------------Good---------------------#
# Create a query
query = from n in Notification,
        join: m in Message, on: m.id == n.message_id,
        join: u in User, on: m.user_id == u.id,
        where: (n.is_seen == false),
        order_by: [desc: n.inserted_at]
# Extend the query
query = from [n,m,u] in query,select: {n.id, m.content,n.inserted_at,m.room_id,u.id,u.first_name,u.last_name}
notifications = Repo.all(query)

#===========================#
# Create another query
query = from n in Notification,
        join: m in Message, on: m.id == n.message_id,
        join: u in User, on: m.user_id == u.id,
        where: (n.is_seen == false),
        order_by: [desc: n.inserted_at]
# Extend the query
query = from [n,m,u] in query,select: %{id: n.id, content: m.content,inserted_at: n.inserted_at,room_id: m.room_id,user_id: u.id,first_name: u.first_name,last_name: u.last_name}
notifications = Repo.all(query)
