SUBROUTINE TF.BD.ID.CHECK.CUSTOMER
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.BD.TF.STUDENTFILE
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing

    GOSUB INITIALIZE
    GOSUB MAIN.PROCESS
RETURN

********************
INITIALIZE:
********************
    FN.CUS="F.CUSTOMER"
    F.CUS=""

    Y.CUS.ID=EB.SystemTables.getIdNew()
RETURN
********************
MAIN.PROCESS:
********************
   
    EB.DataAccess.FRead(FN.CUS,Y.CUS.ID,REC.CUS,F.CUS,ERR.CUS)
    IF REC.CUS EQ "" THEN
        EB.SystemTables.setE('CUSTOMER DOSE NOT EXIST')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
RETURN

END
