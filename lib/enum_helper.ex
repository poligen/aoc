defmodule Aoc.EnumHelper do
  @doc "Returns the frequency map of the given enumerable."
  @spec frequencies(Enumerable.t()) :: %{(value :: any) => count :: non_neg_integer}
  def frequencies(values), do: frequencies_by(values, & &1)

  @doc "Returns the frequency map of the given enumerable, mapping each value with the given function."
  @spec frequencies_by(Enumerable.t(), (value :: any -> value :: any)) :: %{(value :: any) => count :: non_neg_integer}
  def frequencies_by(values, mapper) do
    Enum.reduce(
      values,
      %{},
      fn value, frequency_map -> Map.update(frequency_map, mapper.(value), 1, &(&1 + 1)) end
    )
  end

  @doc "Returns the first element of the given non-empty enumerable."
  @spec first(Enumerable.t()) :: value :: any
  def first(enumerable), do: enumerable |> Enum.take(1) |> hd()

  @doc "Returns the last element of the given non-empty enumerable."
  @spec last(Enumerable.t()) :: value :: any
  def last(enumerable) do
    {:ok, value} = Enum.reduce(enumerable, {:error, :empty}, fn value, _previous -> {:ok, value} end)

    value
  end

  @doc "Returns non-unique values of the input enumerable."
  @spec non_uniques(Enumerable.t()) :: Enumerable.t()
  def non_uniques(enumerable) do
    Stream.transform(
      enumerable,
      MapSet.new(),
      fn value, encountered ->
        if MapSet.member?(encountered, value),
          do: {[value], encountered},
          else: {[], MapSet.put(encountered, value)}
      end
    )
  end

  @doc "Returns true if all elements of the given enumerable are the same."
  @spec all_same?(Enumerable.t()) :: boolean
  def all_same?(enumerable), do: enumerable |> Stream.uniq() |> Enum.take(2) |> Enum.count() == 1
end
