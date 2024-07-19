#if !display
package macros;

import haxe.macro.Context;
import haxe.macro.Expr;

class DevValues
{
    #if SNC_DEV_BUILD
    public static macro function buildNum():ExprOf<Float>
    {
        return macro $v{Context.definedValue('SNC_DEV_BUILD')};
    }
    #end
}
#end