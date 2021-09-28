require 'busted.runner'()

expose("ptusa", function()
    ptusa = require ( 'ptusa_main' )

    it("load", function()
        assert.is_truthy(package.loaded.ptusa_main)    --module is not loaded
        assert.is_truthy( ptusa )

        if no_print_stack_traceback then
            ptusa.no_print_stack_traceback()
        end
    end)

    it("init", function()
        local res = ptusa.init(
            main_script or "main.plua",
            "path", path or "",
            "sys_path", sys_path or "./sys/" )

        assert.are.equal(res, 0)
    end)

    it("has at least one object", function()
        assert.is_truthy( OBJECTS[1] )
    end)

    it("eval() function", function()
        assert.are.equal( ptusa.eval(), 0 )
    end)

    it("objects operations", function()
        for idx, obj in pairs(OBJECTS) do
            local name = obj.name
            print( idx, name, obj.n )
            local operations_cnt = obj:get_modes_count()
            for i = 1, operations_cnt do
                print( "    ", i )

                obj:set_mode( i, 1 )
                assert.are.equal( ptusa.eval(), 0 )

                obj:set_mode( i, 0 )
                assert.are.equal( ptusa.eval(), 0 )
            end
        end
    end)
end)
