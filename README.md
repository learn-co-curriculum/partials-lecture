## Intro

* What is a partial? Code re-use for HTML. Think-keeping our code DRY. 
* General example: Our app displays a user profile page, and an edit user profile page, a new user profile page and an index page of all of the users. Each of these four HTML templates repeat the same, or very similar, code for displaying a user's details--their name, age, and location. But, our project manager has just let us know that our client has decided a user's details should also include their favorite cat. While we commend our client for their excellent taste, we are annoyed that we have to make the *same change* to all four files that display a user's details. Using partials avoids this headache. With a partial, we can extract a portion of our html code, store it in some other file, and simply call, or *render*, the code in that file in any other template. Think of it as making your html code into a method that you can call again and again.

## The Domain Model

Today, we'll be working with a music management app that has a song, artist and genre model. An artist has many songs and a song belongs to an artist. A song has many genres and a genre has many songs. We'll be taking a closer look at a few views in particular: the application.html.erb layout, the song show page, the genre show page and the new and edit pages for the song model.

## Rendering a Simple Partial

Let's take a look at the simple navigation menu that we've provided our music management app. Right now our menu (which has no styling, don't judge), is placed directly in our `views/layouts/application.html` view:

```html
<!DOCTYPE html>
<html>
<head>
  <title>PlaylisterApp</title>
  <%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>
  <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
  <%= csrf_meta_tags %>
</head>
<body>
<p>Menu</p>
<ul>
  <li>
    <%= link_to 'Songs', songs_path %>
  </li>
  <li>
    <%= link_to 'Genres', genres_path %>
  </li>
  <li>
   <%= link_to 'Artists', artists_path %>
  </li>
</ul>

<%= yield %>

</body>
</html>
``` 

Right now, our view is a little disorganized. Its crowded and difficult to read. Imagine an even more complex navigation menu, along with some other content that you might find on this view, like a footer and a sidebar that contains some widgets. Our view would get increasingly difficult to read, understand and edit. Wouldn't it be great if we could organize discrete units of html code, like our menu, by extracting them into their very own files? That's exactly what a partial will do for us. Let's do it. 

* Step 1: Make the partial file: `app/views/layouts/_menu.html.erb`. *Always name partial files with an underscore*. 
* Step 2: Remove the menu code from the application view and place it in the partial:

```html
# app/views/layouts/_menu.html.erb

<p>Menu</p>
<ul>
  <li>
    <%= link_to 'Songs', songs_path %>
  </li>
  <li>
    <%= link_to 'Genres', genres_path %>
  </li>
  <li>
   <%= link_to 'Artists', artists_path %>
  </li>
</ul>
```

* Step 3: Call, or *render*, the partial on the application view. 

```html
# app/views/layouts/application.html.erb

<!DOCTYPE html>
<html>
<head>
  <title>PlaylisterApp</title>
  <%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>
  <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
  <%= csrf_meta_tags %>
</head>
<body>

<%= render 'menu' %>

<%= yield %>

</body>
</html>
```

* Notice that we call the render method with an argument of the name of the partial we want to render, *minus the underscore*. 

Now that we have a basic understanding of how to render a partial to keep our view code organized and DRY, let's take a look at using more complicated partials. 

## Rending Partials with Locals

Notice that the genre show page displays the genre's name, the songs associated with that genre, and some of the details of each of those songs:

```html
<p id="notice"><%= notice %></p>

<p>
  <strong>Genre Name:</strong>
  <%= @genre.name %>
</p>

<br>
<h3>Songs:</h3>
<ul>
  <% @genre.songs.each do |song| %>
    <p>
    <strong>Name:</strong>
      <%= song.name %>
    </p>

    <p>
      <strong>Artist Name:</strong>
      <%= link_to song.artist.name, song.artist if song.artist %>
    </p>
  <%end %>
</ul>

<%= link_to 'Edit', edit_genre_path(@genre) %> |
<%= link_to 'Back', genres_path %>

```

Notice that the song show page also displays the song name and the name of that song's artist:

```html
<p id="notice"><%= notice %></p>

<p>
  <strong>Name:</strong>
  <%= @song.name %>
</p>

<p>
  <strong>Artist Name:</strong>
  <%= link_to @song.artist.name, @song.artist if @song.artist %>
</p>

<p>
  <strong>Genres:</strong>
  <%= @song.genres.collect{|g| g.name}.to_sentence %>
</p>

<%= link_to 'Edit', edit_song_path(@song) %> |
<%= link_to 'Back', songs_path %>
```

This code isn't very dry. We repeat the same code in two locations, and any changes we make to what attributes a song has and how we display them will need to be made in both locations. 

Let's extract this code for displaying a song's name and artist into a partial. 

* Step 1: Create a partial in `views/songs/_song_details.html.erb`.
* Step 2: Place the HTML that displays a song name and it's artist's name in that file:

```html
<p>
  <strong>Name:</strong>
  <%= @song.name %>
</p>

<p>
  <strong>Artist Name:</strong>
  <%= link_to @song.artist.name, song.artist if @song.artist %>
</p>
```

Now, let's render our partial in place of those lines of code on our song show page:

```html
<%= render 'song_details'%>
```

It works! Notice that our partial relies on an instance variable, `@song`, which it implicitly has access to since we set it in the controller action that brought us to this view page. 

**Using Convention**

let's try rendering our partial like this

```html
<%#= render @song %>
```

We get error message missing template songs/song. Rails convention is trying to find a partial that matches the name of the object we are passing in to render. Would this work if we create a song/_song.html.erb that looked just like `_song_details`? Let's try it!

Yes it works, explain a bit about that rails convention but then go back to using song_detail. 



Now Let's try rendering our `_song_detail` partial from our genre show page:

```html
<ul>
  <% @genre.songs.each do |song| %>
    <%= render "songs/song_details" %>
  <%end %>
</ul>
```

Notice that this time, we have to specify which subdirectory of views our partial is found in `/songs`. If a partial is in the same directory as the file on which it is rendered, we can leave this part off. 

Let's visit a genre's show page and see our partial in action. Oh no! We have an error, `undefined method 'name' for nil class`. This error is getting thrown by this line of our partial: `<%= @song.name %>`. Which controller action brought us to the genre show page? `genres#show`, not only did that controller action *not* set a variable, `@song`, for us, but we are actually calling this partial inside our `#each` iteration as we iterate over the collection of the given genre's song. All of this is to say that we do *not* in fact have access to any variable called `@song` on our partial when it is rendered from the genre show page. For this reason, we never want to use instance variables in a partial.

So, how can we solve this? 

* First, we'll replace the instance variable `@song` with a local variable, `song`, on that partial. 
* Then, we'll pass in the value of the local variable when we call `render` on both the song and genre show page, using the following syntax:

```html
# song view

<%= render partial: 'song_details', locals: {song: @song} %>
```

```html
<%= render partial: 'song_details', locals: {song: song} %>
```

In this way, we can dynamically pass in the appropriate song object whenever and wherever we render the partial. Think of it as calling the `render` method with keyword arguments. Each time, we are setting the local variable, `song`, inside of the partial, equal to whatever object gets set to `locals: {song: some_song_object}`. 

## Rendering A Collection via a Partial

Let's take a moment and refactor our rendering of the `song_details` partial on the genre show page. Here, we are using the partial inside of our iteration over a genre's collection of songs. This is such a common practice, that Rails provides us with an even easier way to do it:

```html
<%= render partial: "songs/song_details", collection: @genre.songs, as: :song %>
```

In fact, there is an even more concise way to render a partial with a collection of objects:

```html
<%= render @genre.songs %>
```

However, if we try this approach, we'll see the following error:  (missing template songs/song). Rails is trying to locate a partial using a singular version of the collection we are passing the render method (songs/song). Since we named our partial song_details, this level of abstraction won't work for us. We'll have to use the more explicit version. Let's take a closer look at that now:

```html
<%= render partial: "songs/song_details", collection: @genre.songs, as: :song %>
```

Here, we assign `collection` equal to the collection of songs we want to render and we tell our partial to set the `song` local variable equal to each member of the `@genre.songs` collection. The render method will the work for us of iterating over the given collection and setting each member of that collection equal to the local variable, `song`. 

## Rendering Partials with Local Variables, Form Example

Another common usage of partials is in rendering forms. Let's take a look at the page to edit a song and the view for creating a new song. Notice that the forms are exactly the same! Further, notice that the number of form fields can be a lot to take in. The more form fields we have, the harder it gets to read, understand and edit the form, from the developers point of view. Let's refactor these forms into using partials to render the form fields:

* Step 1: Make a partial, `songs/_form_fields.html.erb`. 
* Step 2: Paste our form fields in the partial
* Step 3: Pass the local variable, `f`, into the partial when we render it on the pages.