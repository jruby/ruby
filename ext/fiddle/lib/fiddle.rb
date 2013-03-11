require 'fiddle.so' unless RUBY_ENGINE == 'jruby'
require 'fiddle/jruby' if RUBY_ENGINE == 'jruby'
require 'fiddle/function'
require 'fiddle/closure'

module Fiddle
  if WINDOWS
    # Returns the last win32 +Error+ of the current executing +Thread+ or nil
    # if none
    def self.win32_last_error
      if RUBY_ENGINE == 'jruby'
        errno = FFI.errno
        errno = nil if errno == 0
      else
        Thread.current[:__FIDDLE_WIN32_LAST_ERROR__]
      end
    end

    # Sets the last win32 +Error+ of the current executing +Thread+ to +error+
    def self.win32_last_error= error
      if RUBY_ENGINE == 'jruby'
       FFI.errno = error || 0
      else
        Thread.current[:__FIDDLE_WIN32_LAST_ERROR__] = error
      end
    end
  end

  # Returns the last +Error+ of the current executing +Thread+ or nil if none
  def self.last_error
    if RUBY_ENGINE == 'jruby'
      errno = FFI.errno
      errno = nil if errno == 0
      errno
    else
      Thread.current[:__FIDDLE_LAST_ERROR__]
    end
  end
  
  # Sets the last +Error+ of the current executing +Thread+ to +error+
  def self.last_error= error
    if RUBY_ENGINE == 'jruby'
      FFI.errno = error || 0
    else
      Thread.current[:__DL2_LAST_ERROR__] = error
      Thread.current[:__FIDDLE_LAST_ERROR__] = error
    end
  end

  # call-seq: dlopen(library) => Fiddle::Handle
  #
  # Creates a new handler that opens +library+, and returns an instance of
  # Fiddle::Handle.
  #
  # See Fiddle::Handle.new for more.
  def dlopen library
    Fiddle::Handle.new library
  end
  module_function :dlopen

  # Add constants for backwards compat

  RTLD_GLOBAL = Handle::RTLD_GLOBAL # :nodoc:
  RTLD_LAZY   = Handle::RTLD_LAZY   # :nodoc:
  RTLD_NOW    = Handle::RTLD_NOW    # :nodoc:
end
