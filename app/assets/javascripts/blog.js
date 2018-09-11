

function postHtml(post)
{
  url = post['url-with-slug']

  more = " <a href='"+url+"'>More...</a>"
  if(post.type == 'regular')
  {
    title = post['regular-title']
    body = post['regular-body']
    if(body.match(/<!-- more -->/))
      body = body.replace(/\n/g," ").replace(/(<\/p>)?\s?<!-- more -->.*/,more)
    else
      body = body+more
  }
  else if(post.type == 'photo')
  {
    title = post['photo-caption'].replace(/<\/?p>/g,"")
    body = "<p><a href='"+url+"'><img src='"+post['photo-url-100']+"'/></a></p>"
    body += "<p>"+more+"</p>"
  }
  t = "<h3><a href='"+url+"'>"+title+"</a></h3>"
  t += "<p class='date'>Posted "+post.date+"</p>"
  t += body
  return "<div class='post'>"+t+"</div>"
}

function blogLoad()
{
  var s = document.createElement('script')
  s.type = 'text/javascript'
  s.async = true
  s.src = "https://pin1yin1.tumblr.com/api/read/json"
  var s0 = document.getElementsByTagName('script')[0]
  s0.parentNode.insertBefore(s, s0)
}

function blogSetup()
{
  blogLoad()
  
  blogWait()
}

function blogWait()
{
  if(typeof tumblr_api_read === 'undefined')
  {
    setTimeout(blogWait, 1000)
    return
  }

  posts = tumblr_api_read.posts

  $("#blogtop").html(postHtml(posts[0]))
  t = ""
  for(i=1;i<posts.length && i<3;i++)
  {
    t += postHtml(posts[i])
  }
  $("#blogmore").html(t)
}

