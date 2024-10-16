defmodule TestSCSS.Sigil do
  alias TestSCSS.CSSTranslator

  import Phoenix.Component

  defmacro __using__(opts \\ []) do
    if not Module.has_attribute?(__CALLER__.module, :__style__) do
      Module.register_attribute(__CALLER__.module, :__style__, accumulate: true)
    end

    if not Module.has_attribute?(__CALLER__.module, :__function_style__) do
      Module.register_attribute(__CALLER__.module, :__function_style__, [])
    end

    quote do
      import TestSCSS.Sigil

      @before_compile unquote(__MODULE__)
      @on_definition unquote(__MODULE__)
    end
  end

  def __on_definition__(env, kind, name, args, guards, body) do
    # dbg(env)
    dbg(kind)
    dbg(name)
    # dbg(args)
    # dbg(guards)

    case Module.delete_attribute(env.module, :__function_style__) do
      nil -> :ok
      css ->
        scope = scope(env.module, name)

        opts = [
          scope: scope,
          file: env.file,
          line: env.line + 1
        ]

        style = CSSTranslator.translate!(css, opts)

        Module.put_attribute(env.module, :__style__, style)
    end
  end

  # defp scope(module, :render), do: CSSTranslator.scope_id(module)
  defp scope(module), do: CSSTranslator.scope_id(module)
  defp scope(module, function), do: CSSTranslator.scope_id(module, function)

  defmacro __before_compile__(env) do
    style = Module.get_attribute(env.module, :__style__)

    # dbg(Module.get_attribute(env.module, :__attrs__))

    quote do
	    def __style__() do
        unquote(Macro.escape(style))
      end
    end
  end

  defmacro sigil_CSS({:<<>>, _, [css]}, []) do
    quote do
      TestSCSS.CSSParser.parse!(unquote(css))
    end
  end

  # defmacro sigil_SCSS({:<<>>, _, [string]}, []) do
  #   # unless Macro.Env.has_var?(__CALLER__, {:assigns, nil}) do
  #   #   raise "~SCSS requires a variable named \"assigns\" to exist and be set to a map"
  #   # end

  #   scope =
  #     case __CALLER__.function do
  #       nil -> CSSTranslator.scope_id(__CALLER__.module)
  #       {function, _} -> CSSTranslator.scope_id(__CALLER__.module, function)
  #     end

  #   # {function, _} = __CALLER__.function

  #   # dbg(__CALLER__.function)
  #   opts = [
  #     scope: scope,
  #     file: __CALLER__.file,
  #     line: __CALLER__.line + 1
  #   ]

  #   style = CSSTranslator.translate!(string, opts)

  #   Module.put_attribute(__CALLER__.module, :__style__, style)

  #   # quote do
	#   #   def __style__() do
  #   #     unquote(Macro.escape(style))
  #   #   end
  #   # end
  #   # Module.put_attribute(__CALLER__.module, :__style__, {elem(__CALLER__.function, 0), style})


  #   # style = "<style>#{css}</style>"
  #   quote do
  #     :ok
  #   end
  #   # quote do
  #   #   sigil_H(unquote({:<<>>, _meta = [], [""]}), [])
  #   # end
  # end

  # defmacro sigil_SCSS({:<<>>, _, [string]}, []) do
  #   unless Macro.Env.has_var?(__CALLER__, {:assigns, nil}) do
  #     raise "~SCSS requires a variable named \"assigns\" to exist and be set to a map"
  #   end

  #   # {function, _} = __CALLER__.function

  #   opts = [
  #     # scope: CSSTranslator.scope_id(__CALLER__.module, function),
  #     scope: CSSTranslator.scope_id(__CALLER__.module),
  #     file: __CALLER__.file,
  #     line: __CALLER__.line + 1
  #   ]

  #   %{css: css} = CSSTranslator.translate!(string, opts)

  #   style = "<style>#{css}</style>"

  #   quote do
  #     sigil_H(unquote({:<<>>, _meta = [], [style]}), [])
  #   end
  # end

  defmacro scss(css_ast) do
    quote do
      Module.put_attribute(unquote(__CALLER__.module), :__function_style__, unquote(css_ast))
    end
  end

  defmacro module_scss(css_ast) do
    scope = CSSTranslator.scope_id(__CALLER__.module)

    opts = [
      scope: scope,
      file: __CALLER__.file,
      line: __CALLER__.line + 1
    ]

    quote do
      style = CSSTranslator.translate!(unquote(css_ast), unquote(opts))

      Module.put_attribute(unquote(__CALLER__.module), :__style__, style)
    end
  end

  defmacro scss do
    module_scope = CSSTranslator.scope_id(__CALLER__.module)

    {function, _} = __CALLER__.function

    function_scope = CSSTranslator.scope_id(__CALLER__.module, function)

    quote do
      %{"s-#{unquote(module_scope)}" => true, "s-#{unquote(function_scope)}" => true}
    end
  end
end
