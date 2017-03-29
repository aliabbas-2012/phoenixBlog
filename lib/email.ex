defmodule BlogTest.Email do
  use Bamboo.Phoenix, view: BlogTest.EmailView

  def welcome_text_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("us@example.com")
    |> subject("Welcome!")
    # |> text_body("Welcome to MyApp!")
    |> put_text_layout({BlogTest.LayoutView, "email.text"})
    |> render("welcome.text")
  end

  def welcome_html_email(email_address) do
    email_address
    |> welcome_text_email()
    # |> html_body("<strong>Welcome<strong> to MyApp!")
    |> put_html_layout({BlogTest.LayoutView, "email.html"})
    |> render("welcome.html")
  end
  #for user
  def welcome_and_confirmation_email(%{changes: changes} = changeset) do
    new_email()
    |> to(changes.email)
    |> from("no_reply@blogtest.com")
    |> subject("Welcome to Blog Test!")
    |> put_html_layout({BlogTest.LayoutView, "email.html"})
    |> render("welcome_and_confirmation.html",model: changes)
  end
end
