require 'busted.runner'()

expose("ptusa", function()
    ptusa = require ( 'main_control' )

    it("load", function()
        assert.is_truthy(package.loaded.main_control)    --module is not loaded
        assert.is_truthy( ptusa )

        if no_print_stack_traceback then
            ptusa.no_print_stack_traceback()
        end
    end)

    it("init", function()
        local res = ptusa.init(
            main_script or "main.plua",
            "path", path or "",
            "sys_path", sys_path or "./sys-scripts/" )

        assert.are.equal(res, 0)

        print( user_init )
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
                local m_mngr = obj:get_modes_manager()
                local oper = m_mngr[ i ]
                local count_steps = oper[ operation.RUN ]:steps_count()
                for j = 1, count_steps do
                    print( "\t"..j )
                    oper:to_step( j )
                end
                obj:set_mode( i, 0 )
                assert.are.equal( ptusa.eval(), 0 )
            end
        end
    end)
end)
