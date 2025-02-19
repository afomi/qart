defmodule Qart.Inventory.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :status, :string
    field :description, :string
    field :price, :decimal
    field :tags, {:array, :string}, default: []
    field :images, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    attrs = normalize_tags(attrs)

    item
    |> cast(attrs, [:name, :description, :price, :tags, :status])
    |> validate_required([:name, :description])
  end

  defp normalize_tags(%{"tags" => tags} = attrs) when is_binary(tags) do
    tags_list =
      tags
      |> String.split(",") # Split by comma
      |> Enum.map(&String.trim/1) # Trim whitespace
      |> Enum.reject(&(&1 == "")) # Remove empty entries

    Map.put(attrs, "tags", tags_list)
  end

  # Return unchanged if not a binary
  defp normalize_tags(attrs), do: attrs
end
