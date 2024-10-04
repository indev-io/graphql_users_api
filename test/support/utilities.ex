defmodule GraphqlUsersApi.Support.Utilities do
  def camel_case_string_to_snake_case_atom(str) do
    str
    |> Macro.underscore
    |> String.to_atom
  end

  def snake_case_atom_to_camel_case_string(atm) do
    [first_letter | rest] =
      atm
    |> Atom.to_string
    |> Macro.camelize
    |> String.graphemes

  Enum.join([String.downcase(first_letter) |rest])
  end


end
