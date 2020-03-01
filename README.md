# SHOWOFF

This is a Showoff test that consumes an API to handle widgets and user authentication

## Specifications
Ruby 2.5.1
Rails 5.2.4

## Custom Gems
```ruby
gem 'haml-rails', '~> 2.0' # Convert html.erb to Haml
```

```ruby
gem 'rest-client' # Requests to APIs
```

```ruby
group :development do
  gem 'better_errors' # See errors console on web
  gem 'binding_of_caller'
end
```

```ruby
gem 'hash_dot' # Access to Hashes using dot notation
```

## Installation
```bash
$ cd Showoff
```
```bash
$ bundle install
```
```bash
$ rails s
```

## Usage
1 Navbar:
  - Search bar to look for some visible widgets
  - If you're logged in
    - A dropdown with options:
      - Link to My Profile
      - Link to My Widgets
      - Link to Log Out
  - If you are not logged in
    - Button to log in modal
    - Button to sign up modal

2. Landing Page:
  - List of Visible Widgets with:
    - ID
    - NAME
    - KIND
    - USER (link to modal)

3. User Show (Me or ID)
  - User's Image
  - If (Me):
    - Edit Profile Modal Button
    - Change Password Modal Button
  - User's Name
  - User's Email
  - User's Date of Birth
  - List of User's widgets
  - Search bar to look fot User's widgets
  - Create User's Widget button

4. My Widgets
  - List of my widgets
  - Search bar to look fot my widgets
  - Create Widget button
