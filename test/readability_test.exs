defmodule ReadabilityTest do
  use ExUnit.Case, async: true

  test "readability for NY Times" do
    html = TestHelper.read_fixture("nytimes.html")
    opts = [clean_conditionally: false]
    nytimes = Readability.article(html, opts)

    nytimes_html = Readability.readable_html(nytimes)
    assert nytimes_html =~ ~r/^<div><div class="story-body"><figure id="media-100000004245260" class="media photo lede layout-large-horizontal"><div class="image"><img src="https:\/\/static01.nyt/
    assert nytimes_html =~ ~r/major priorities.<\/p><\/div><\/div>$/

    nytimes_text = Readability.readable_text(nytimes)
    assert nytimes_text =~ ~r/^Buddhist monks performing as part of/
    assert nytimes_text =~ ~r/one of her major priorities.$/
  end

  test "readability for BBC" do
    html = TestHelper.read_fixture("bbc.html")
    bbc = Readability.article(html)

    bbc_html = Readability.readable_html(bbc)

    assert bbc_html =~ ~r/^<div><div class="story-body__inner"><figure class="media-landscape no-caption full-width lead"><span class="image-and-copyright-container"><img class="js-image-replace" src="http:\/\/ichef/
    assert bbc_html =~ ~r/connected computing devices".<\/p><\/div><\/div>$/

    bbc_text = Readability.readable_text(bbc)
    # TODO: Remove image caption when extract only text
    # assert bbc_text =~ ~r/^Microsoft\'s quarterly profit has missed analysts/
    assert bbc_text =~ ~r/connected computing devices".$/
  end

  test "readability for medium" do
    html = TestHelper.read_fixture("medium.html")
    opts = [clean_conditionally: false]
    medium = Readability.article(html, opts)

    medium_html = Readability.readable_html(medium)

    assert medium_html =~ ~r/<strong class="markup--strong markup--p-strong"><em class="markup--em markup--p-em">Background: <\/em><\/strong><em class="markup--em markup--p-em">I’ve spent the past 6 years building web applications in Ruby and the Rails framework/
    assert medium_html =~ ~r/recommend button!<\/em><\/h3><\/div><\/div>$/

    medium_text = Readability.readable_text(medium)

    assert medium_text =~ ~r/^Background:/
    assert medium_text =~ ~r/a lot to me if you hit the recommend button!$/
  end

  test "readability for medium 2" do
    html = TestHelper.read_fixture("medium2.html")
    opts = [clean_conditionally: false]
    medium = Readability.article(html, opts)

    medium_html = Readability.readable_html(medium)

    assert medium_html =~ "Lastly, after much design philosophizing as to whether our logo should be rendered in "
  end

  test "readability for buzzfeed" do
    html = TestHelper.read_fixture("buzzfeed.html")
    buzzfeed = Readability.article(html)

    buzzfeed_html = Readability.readable_html(buzzfeed)

    assert buzzfeed_html =~ ~r/<div><div class="buzz_superlist_item_text"><div class="buzz_superlist_item buzz-superlist-item buzz_superlist_item_image buzz-superlist-item-image buzz_superlist_item_narrow image_lfcn no_caption " id="superlist_4226947_8509394" rel:buzz_num="1"><div class="solid"><div class="sub_buzz_content"><img src="data:image\/gif;base64,R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==" rel:bf_image_src="https:\/\/img.buzzfeed.com\/buzzfeed-static\/static\/2016-04\/22\/21\/enhanced\/webdr06\/enhanced-mid-24263-1461375796-1.jpg" class="bf_dom" rel:bf_bucket="progload" width="720" height="488"\/><p class="print"><a href="https:\/\/img.buzzfeed.com\/buzzfeed-static\/static\/2016-04\/22\/21\/enhanced\/webdr06\/enhanced-mid-24263-1461375796-1.jpg" rel="nofollow"><b>View this image ›<\/b><\/a><\/p><\/div><p class="article_caption_w_attr"><span class="sub_buzz_source_via buzz_attribution buzz_attr_no_caption">Carolyn Kaster \/ AP<\/span><\/p><\/div><\/div><p>The FBI no longer needs Apple’s help/

    refute buzzfeed_html =~ "<hr><hr><hr>"

    buzzfeed_text = Readability.readable_text(buzzfeed)

    assert buzzfeed_text =~ ~r/The FBI no longer needs Apple’s help/
  end

  test "readability for pubmed" do
    html = TestHelper.read_fixture("pubmed.html")
    pubmed = Readability.article(html)

    pubmed_html = Readability.readable_html(pubmed)

    assert pubmed_html =~ ~r/^<div><div class=""><h4>BACKGROUND AND OBJECTIVES: <\/h4><p><abstracttext>Although strict blood pressure/
    assert pubmed_html =~ ~r/different mechanisms yielded potent antihypertensive efficacy with safety and decreased plasma BNP levels.<\/abstracttext><\/p><\/div><\/div>$/

    pubmed_text = Readability.readable_text(pubmed)

    assert pubmed_text =~ ~r/^BACKGROUND AND OBJECTIVES: \nAlthough strict blood pressure/
    assert pubmed_text =~ ~r/with different mechanisms yielded potent antihypertensive efficacy with safety and decreased plasma BNP levels.$/
  end

  test "readability for tomaz" do
    html = TestHelper.read_fixture("tomaz.html")
    tomaz = Readability.article(html)
    tomaz_html = Readability.readable_html(tomaz)

    refute tomaz_html =~ "© 2016. All rights reserved."
  end


  test "readability for newyorker" do
    html = TestHelper.read_fixture("newyorker.html")
    article = Readability.article(html)
    html = Readability.readable_html(article)

    refute html =~ "Join the others who've found our articles helpful!"
  end

  test "readability for ycombinator" do
    html = TestHelper.read_fixture("ycombinator.html")
    article = Readability.article(html)
    html = Readability.readable_html(article)

    assert html =~ "I hadn't replied to this because others had already provided all of the info I have. To summarize, the author of notty[0] and I are talking about a collaboration[1]. notty has done a ton of pathfinding in this area on identifying"
  end

  # test "readability for buzzfeed (url)" do
  #   html = Readability.summarize("https://www.buzzfeed.com/salvadorhernandez/fbi-obtains-passcode-to-iphone-in-new-york-drops-case-agains").article_html
  #   assert html =~ "In New York, as in San Bernardino, an imminent courtroom battle was averted"
  # end


  # test "readability for newyorker url" do
  #   html = Readability.summarize("http://www.newyorker.com/magazine/2017/01/09/the-vertical-farm").article_html
  
  #   transformed_images = html |> Floki.find("img") |> Floki.attribute("src")
  #   IO.inspect transformed_images

  #   refute html =~ "Buy a cartoon"
  # end

  # test "readability for medium url (follow redirect)" do
  #   html = Readability.summarize("https://blog.medium.com/the-story-behind-medium-s-new-logo-4cd3e143dfcf#.jv0iq9j3x").article_html
  #   assert html =~ "Lastly, after much design philosophizing"
  # end

end
