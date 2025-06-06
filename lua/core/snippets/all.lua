local ls   = require("luasnip")
local s    = ls.snippet
local t    = ls.text_node
local i    = ls.insert_node
local c    = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta


return {
    s(
        {
            trig = "\"",
            snippetType = "snippet",
            desc = "quotation marks",
            wordTrig = false,
        },
        fmta(
            [["<>"]],
            { i(1, "text"), }
        )
    ),

    s(
        {
            trig = "{}",
            snippetType = "snippet",
            desc = "Csharp type bracket spacing",
            wordTrig = false,
        },
        fmta(
            [[
            {
                <>
            }
            ]],
            { i(1, ""), }
        )
    ),

    s(
        {
            trig = "(){}",
            snippetType = "snippet",
            desc = "start Function shortcut",
            wordTrig = false,
        },
        fmta(
            [[()
{
    <>
}
            ]],
            { i(1, ""), }
        )
    ),

}
