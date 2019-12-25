defmodule Issues.GithubIssues do
  @user_agent [{"User-Agent", "Elixir dave@pragprog.com"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  @github_url Application.get_env(:issues, :github_url)

  def issues_url(user, project), do: "#{@github_url}/repos/#{user}/#{project}/issues"

  def handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!()
    }
  end

  defp check_for_error(200), do: :ok

  defp check_for_error(_), do: :error


#  def handle_response({:ok, %{status_code: 200, body: body}}), do: {:ok, body}
#
#  def handle_response({_, %{status_code: _, body: body}}), do: {:error, body}
end
