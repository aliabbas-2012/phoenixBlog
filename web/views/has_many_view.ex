defmodule BlogTest.HasManyView do
  use BlogTest.Web, :view

  import BlogTest.ApplicationHelpers
  alias BlogTest.Address
  alias BlogTest.User

  def render_addresses(p,is_template) do
    render "_address_fields.html", f: p,is_template: is_template
  end

  def link_to_address_fields do
   changeset = User.changeset(%User{addresses: [%Address{}]})
   form = Phoenix.HTML.FormData.to_form(changeset, [])
   fields = render_to_string(__MODULE__, "_address_template.html", f: form)
   link "Add Address", to: "javascript:void(0);", "data-template": fields, id: "add_address",class: "btn btn-block btn-primary btn-sm"
  end

end
