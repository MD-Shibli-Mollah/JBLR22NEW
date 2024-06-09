SUBROUTINE GB.JBL.V.STOCK.REG
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.SystemTables

    Y.COM = EB.SystemTables.getIdCompany()
    Y.STOCK.REG = "DRAFT.":Y.COM
    EB.SystemTables.setComi(Y.STOCK.REG)
    
RETURN
END
