defmodule Issues.Formatter do
  def format(issues) do
    issues = issues |> transform |> prepend_header
    max_lengths = find_max_lengths(issues)
    issues
    |> insert_separator(max_lengths)
    |> Enum.map(&(format_row(&1, max_lengths)))
  end

  defp transform(issues) do
    for %{"id" => id, "created_at" => created_at, "title" => title} <- issues, do: [Integer.to_string(id), created_at, title]
  end

  defp prepend_header(issues), do: [["#", "created_at", "title"] | issues]

  defp insert_separator(issues, max_lengths) do
    List.insert_at(issues, 1, create_separator(max_lengths))
  end

  defp create_separator(max_lengths) do
    for n <- max_lengths, do: String.duplicate("-", n)
  end

  defp find_max_lengths(rows) do
    init_acc = for _n <- List.first(rows), do: 0
    reducer = fn row, acc -> find_max(row, acc) end
    Enum.reduce(rows, init_acc, reducer)
  end

  defp find_max(row, acc) do
    row
    |> Enum.with_index
    |> Enum.map(fn {col, index} -> Enum.max([String.length(col), Enum.fetch!(acc, index)]) end)
  end

  defp format_row(columns, max_lengths) do
    columns
    |> Enum.with_index
    |> Enum.map(fn {col, index} -> String.pad_trailing(col, Enum.fetch!(max_lengths, index)) end)
    |> Enum.join(" | ")
  end
end
