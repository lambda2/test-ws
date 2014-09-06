var casper = require('casper').create();

var ecrireHellSurUneNouvelleLigne = function(_casper)
{
    _casper.click("#post_content")
    _casper.page.sendEvent("keypress", _casper.page.event.key.Enter);
    _casper.page.sendEvent("keypress", _casper.page.event.key.H);
    _casper.page.sendEvent("keypress", _casper.page.event.key.E);
    _casper.page.sendEvent("keypress", _casper.page.event.key.L);
    _casper.page.sendEvent("keypress", _casper.page.event.key.L);
}

var alphabey = function(_casper)
{
    for (var i = 0; i < 2; i++)
    {
        for (var i = 0; i < 20; i++)
        {
            _casper.click("#post_content");
            _casper.sendKeys("#post_content", "abc", { keepFocus: true });
            _casper.echo('abc');
        }
        _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
        _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
        _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
        for (var i = 0; i < 20; i++)
        {
            _casper.click("#post_content");
            _casper.sendKeys("#post_content", "abc", { keepFocus: true });
            _casper.echo('abc');
            _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
            _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
            _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
        }
        _casper.page.sendEvent("keypress", _casper.page.event.key.Backspace);
        _casper.page.sendEvent("keypress", _casper.page.event.key.Backspace);
        _casper.page.sendEvent("keypress", _casper.page.event.key.Backspace);
        for (var i = 0; i < 20; i++)
        {
            _casper.click("#post_content");
            _casper.sendKeys("#post_content", "abc", { keepFocus: true });
            _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
            _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
            _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
            _casper.sendKeys("#post_content", "abc", { keepFocus: true });
            _casper.sendKeys("#post_content", "abc", { keepFocus: true });
            _casper.sendKeys("#post_content", "abc", { keepFocus: true });
            _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
            _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
            _casper.page.sendEvent("keypress", _casper.page.event.key.Left);
            _casper.page.sendEvent("keypress", _casper.page.event.key.Delete);
            _casper.page.sendEvent("keypress", _casper.page.event.key.Delete);
            _casper.page.sendEvent("keypress", _casper.page.event.key.Delete);
            _casper.echo('abc');
        }
    }
    // _casper.page.sendEvent("keypress", _casper.page.event.key.S);
    // _casper.page.sendEvent("keypress", _casper.page.event.key.A);
    // _casper.page.sendEvent("keypress", _casper.page.event.key.L);
    // _casper.page.sendEvent("keypress", _casper.page.event.key.U);
    // _casper.page.sendEvent("keypress", _casper.page.event.key.T);
}

casper.start("http://localhost:10000/posts/1/edit", function()
{
    this.wait(2000, function()
    {
        alphabey(this);
        //
        // this.wait(1000, function()
        // {
        //     this.click("#post_content")
        //     this.echo("One HELL");
        //     ecrireHellSurUneNouvelleLigne(this);
        //
        //     this.wait(1000, function()
        //     {
        //         this.echo("Another HELL");
        //         ecrireHellSurUneNouvelleLigne(this);
        //     });
        // });
    });

})

casper.run();
