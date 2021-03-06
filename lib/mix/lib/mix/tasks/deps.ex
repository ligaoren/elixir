defmodule Mix.Tasks.Deps do
  use Mix.Task

  import Mix.Deps, only: [loaded: 0, format_dep: 1, format_status: 1, check_lock: 2]

  @shortdoc "List dependencies and their status"

  @moduledoc """
  List all dependencies and their status.
  The output is given as follows:

    * APP VERSION (SCM)
      [locked at REF]
      STATUS

  """
  def run(_) do
    Mix.Project.get! # Require the project to be available

    shell = Mix.shell
    lock  = Mix.Deps.Lock.read

    Enum.each loaded, fn(Mix.Dep[scm: scm] = dep) ->
      dep = check_lock(dep, lock)
      shell.info "* #{format_dep(dep)}"
      if formatted = scm.format_lock(dep.opts) do
        shell.info "  locked at #{formatted}"
      end
      shell.info "  #{format_status dep}"
    end
  end
end
