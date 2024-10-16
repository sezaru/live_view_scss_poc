# defmodule TestSCSS do
#   import TestSCSS.Sigil

#   def run do
#     state = TestSCSS.Tokenizer.init(0, "", [], TestSCSS.HTMLEngine)

#     text = """
#     <section>
#       <div class=\"blibs\" />
#     </section>
#     """

#     TestSCSS.Tokenizer.tokenize(text, [], [], :style, state)
#   end

#   def run2 do
#     css = """
#     .tag {
#       @apply bg-gray-200;
#     }
#     """

#     TestSCSS.CSSTokenizer.tokenize!(css)
#   end

#   def run3 do
#     css = """
#     .tag {
#       @apply bg-gray-200;
#     }
#     """

#     TestSCSS.CSSTranslator.translate!(css, scope: HueHua)
#   end

#   def run4(assigns \\ %{}) do
#     ~SCSS"""
#     .tag {
#       @apply bg-gray-200;
#     }
#     """
#   end

#   def run5(assigns \\ %{class: "bg-gray-200"}) do
#     ~SCSS"""
#     .tag {
#       @apply <%= @class %>;
#     }
#     """
#   end
# end
