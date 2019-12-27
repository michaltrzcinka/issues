defmodule FormatterTest do
  use ExUnit.Case
  doctest Issues

  import Issues.Formatter, only: [format: 1]

  test "formatting" do
    #    assert parse_args(["-h", "anything"]) == :help
    assert format(fake_issues) ==
             [
               "# | created_at           | title                                                                     ",
               "- | -------------------- | --------------------------------------------------------------------------",
               "1 | 2019-11-27T17:10:30Z | Support Erlang 23 new features                                            ",
               "2 | 2019-12-14T19:09:39Z | Support adding additional files to a Mix release, i.e. Distillery overlays",
             ]
  end

  defp fake_issues do
    [
      %{"id" => 1, "created_at" => "2019-11-27T17:10:30Z", "title" => "Support Erlang 23 new features"},
      %{
        "id" => 2,
        "created_at" => "2019-12-14T19:09:39Z",
        "title" => "Support adding additional files to a Mix release, i.e. Distillery overlays"
      },
    ]
  end
end
