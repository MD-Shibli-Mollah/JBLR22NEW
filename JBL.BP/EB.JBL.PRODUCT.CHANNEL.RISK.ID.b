SUBROUTINE EB.JBL.PRODUCT.CHANNEL.RISK.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.JBL.PRODUCT.CHANNEL.RISK
    $USING EB.SystemTables
    
    Y.ID.CHK= EB.SystemTables.getIdNew()
    IF Y.ID.CHK NE 'SYSTEM' THEN
        EB.SystemTables.setE("ID MUST BE SYSTEM")
        RETURN

    END
