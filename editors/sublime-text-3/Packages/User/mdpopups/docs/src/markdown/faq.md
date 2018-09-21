# F.A.Q

## Questions

- **Why don't `#!html <pre>` tags work right when I do them, but MdPopups' work correctly?**

    This is because the HTML engine in Sublime treats `#!html <pre>` tags just as a normal block elements; it doesn't treat the content as preformatted.  When MdPopups creates code blocks, it actually does a lot of special formatting to the blocks.  It converts tabs to 4 spaces, and spaces are converted to `#!html &nbsp;` to prevent wrapping.  Lastly, new lines get converted to `#!html <br>` tags.
    {: style="font-style: italic"}

- **Why in code blocks do tabs get converted to 4 spaces?**

    Because I like it that way.  If you are planning on having a snippet of text sent through the syntax highlighter and do not want your tabs to be converted to 4 spaces, you should convert it to the number of spaces you like **before** sending it through the syntax highlighter.
    {: style="font-style: italic"}

- **Why does &lt;insert element&gt; not work, or cause the popup/phantom not to show?**

    Because Sublime's HTML engine is extremely limited or the element you are trying to use hasn't been styled correctly yet. Though I do not have a complete list of all supported elements, you can check out the provided `default.css` on the repository to see what is supported. There are probably some elements you could style and then would work correctly, but there are others like `#!html <table>` will not *currently* work. In general, you should keep things basic, but feel free to experiment to get an understanding of Sublime's `minihtml` engine limitations.
    {: style="font-style: italic"}
