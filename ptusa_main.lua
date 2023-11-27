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

    it("eval() function", function()
        assert.are.equal( ptusa.eval(), 0 )
    end)

    it("objects operations", function()
        if OBJECTS then
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
        end
    end)

    it("objects number and type", function()
        if OBJECTS then
            for idx, obj in pairs(OBJECTS) do
                print( idx, obj.name, obj.n, "("..obj.tech_type..")" )
            end

            local err_str = ""
            for _, obj in pairs(OBJECTS) do
                local n = obj.n
                local tech_type = obj.tech_type

                for _, obj2 in pairs(OBJECTS) do
                    if obj ~= obj2 then
                        if n == obj2.n and tech_type == obj2.tech_type then
                            err_str = err_str.."\n    '"..obj2.name..
                                "' has the same number ("..n..") and type ("..tech_type..
                                ") as '"..obj.name.."'."
                        end
                    end
                end
            end

            if err_str ~= "" then error( "Not correct objects description:"..err_str ) end
        end
    end)

    it("check same names", function()
        if OBJECTS then
            for _, idx in pairs( OBJECTS ) do
                for i = 1, #idx.NAME_PARAMS do
                    for j = 1, i - 1 do
                        if idx.NAME_PARAMS[ i ] ~= 'P' and idx.NAME_PARAMS[ j ] ~= 'P' then
                            if idx.NAME_PARAMS[ i ] == idx.NAME_PARAMS[ j ] then
                                print( idx.name..' '..idx.n..' '..idx.NAME_PARAMS[ i ]..' has some same names Lua' )
                            end
                        end
                    end
                end
            end
        end
    end)
end)
