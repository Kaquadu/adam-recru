# Write an implementation for square root without using :math or external libs.

defmodule NewMath do
  def sqrt(number, precision) do
    {lower, upper} = find_boundaries(1,2,number)

    :erlang.float_to_binary( do_sqrt(lower, upper, number, 1, precision), decimals: 2)
  end

  ###

  defp do_sqrt(lower, upper, _, _, _) when lower == upper, do: upper/1

  defp do_sqrt(lower_boundary, upper_boundary, number, current_precision, target_precision)
      when current_precision == target_precision do
    step = 1/10 ** current_precision

    boundaries = create_boundaries(target_precision, lower_boundary, upper_boundary, step, [])

    {new_lower_boundary, new_upper_boundary} = find_matching_boundaries(boundaries, number)

    lower_sub = number - new_lower_boundary
    upper_sub = number - new_upper_boundary

    if lower_sub > upper_sub, do: new_upper_boundary, else: new_lower_boundary
  end

  defp do_sqrt(lower_boundary, upper_boundary, number, current_precision, target_precision) do
    step = 1/10 ** current_precision

    boundaries = create_boundaries(target_precision, lower_boundary, upper_boundary, step, [])

    {new_lower_boundary, new_upper_boundary} = find_matching_boundaries(boundaries, number)

    do_sqrt(new_lower_boundary, new_upper_boundary, number, current_precision+1, target_precision)
  end

  defp find_matching_boundaries([{lower, upper} | t], number) do
    if s_pow(lower) < number and s_pow(upper) > number do
      {lower, upper}
    else
      find_matching_boundaries(t, number)
    end
  end

  defp create_boundaries(_target_precision, lower_boundary, upper_boundary, _step, acc) when lower_boundary >= upper_boundary, do: acc

  defp create_boundaries(target_precision, lower_boundary, upper_boundary, step, acc) do
    new_lower_boundary = lower_boundary + step


    # here it adds some decimal numbers to boundaries out of nowhere
    # that was the easies solution I could think of
    # at the moment
    boundaries = {
      Float.round(lower_boundary/1, target_precision),
      Float.round(new_lower_boundary,target_precision)
    }

    create_boundaries(target_precision, new_lower_boundary, upper_boundary, step, [ boundaries | acc ])
  end

  defp find_boundaries(lower_boundary, upper_boundary, number) do
    cond do
      s_pow(lower_boundary) < number and s_pow(upper_boundary) > number ->
        {lower_boundary, upper_boundary}
      s_pow(lower_boundary) < number and s_pow(upper_boundary) >= number ->
        {upper_boundary, upper_boundary}
      s_pow(lower_boundary) <= number and s_pow(upper_boundary) >= number ->
        {lower_boundary, lower_boundary}
      true ->
        find_boundaries(lower_boundary+1, upper_boundary+1, number)
    end
  end

  defp s_pow(a), do: a ** 2
end

IO.inspect(NewMath.sqrt(1, 2)) # => 1.00
IO.inspect(NewMath.sqrt(8, 2)) # => 2.82
IO.inspect(NewMath.sqrt(10, 2)) # => 3.16
IO.inspect(NewMath.sqrt(16, 2)) # => 4.00
IO.inspect(NewMath.sqrt(24, 2)) # => 4.90
IO.inspect(NewMath.sqrt(81, 2)) # => 9.00


defmodule BinaryTree do
  defmodule Node do
    defstruct ~w(value left right)a
  end

  def insert(%{value: v, left: l, right: r}) do
    %__MODULE__.Node{
      value: v,
      left: insert_node(l),
      right: insert_node(r)
    }
  end

  def dfs(tree, value) do
    do_dfs(tree, value)
  end

  ###

  defp do_dfs(%{value: v, left: _l, right: _r}, searched_value) when searched_value == v, do: "Found node value: #{v}"

  defp do_dfs(%{value: _v, left: nil, right: nil}, _searched_value), do: nil

  defp do_dfs(%{value: _v, left: left, right: nil}, searched_value) do
    do_dfs(left, searched_value)
  end

  defp do_dfs(%{value: _v, left: nil, right: right}, searched_value) do
    do_dfs(right, searched_value)
  end

  defp do_dfs(%{value: _v, left: left, right: right}, searched_value) do
    do_dfs(left, searched_value) || do_dfs(right, searched_value)
  end

  defp insert_node(%{value: _v, left: _l, right: _r} = node) do
    insert(node)
  end

  defp insert_node(nil), do: nil
end

tree = %{
  value: 1,
  left: %{
    value: 2,
    left: nil,
    right: nil
  },
  right: %{
    value: 2,
    left:  %{
      value: 5,
      left: nil,
      right: nil
    },
    right: nil
  }
}

tree
|> BinaryTree.insert()
|> BinaryTree.dfs(2) |> IO.inspect()
