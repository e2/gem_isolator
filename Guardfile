# frozen_string_literal: true

# A hack to allow splitting Guardfile into multiple files
module GuardBlockWrapper
  def around_guard(filename, options = {})
    @guard_overriding_options = options
    @guard_block_wrapper = proc do |original_guard_body_block|
      if block_given?
        yield(original_guard_body_block)
      else
        original_guard_body_block.call
      end
    end

    instance_eval(IO.read(filename), filename, 1)
    @guard_block_wrapper = nil
  end

  def guard(name, options = {}, &block)
    @guard_overriding_options ||= {}
    new_options = options.merge(@guard_overriding_options)
    return super(name, new_options) unless @guard_block_wrapper
    super(name, new_options) { @guard_block_wrapper.call(block) }
  end

  def template_path_for(name)
    filename = ".guard/#{name}.rb"
    return filename if File.exist?(filename)
    raise NotImplementedError, "Expected #{filename} to exist"
  end

  def load_guard(name, *args, &block)
    around_guard(template_path_for(name), *args, &block)
  end
end

self.class.prepend GuardBlockWrapper

group :specs, halt_on_fail: true do
  load_guard(:rubocop)
  load_guard(:rspec, mode: :keep)
end

load_guard(:bundler)
