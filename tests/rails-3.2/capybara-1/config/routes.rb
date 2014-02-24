# encoding: utf-8

SpreewaldTest::Application.routes.draw do
  match ':controller(/:action(/:id(.:format)))'
end
