SUBROUTINE TF.BD.I.FDD.STD.ID
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
    Y.CUS.MNEMONIC=''
RETURN
********************
MAIN.PROCESS:
********************
   
    EB.DataAccess.FRead(FN.CUS,Y.CUS.ID,REC.CUS,F.CUS,ERR.CUS)
    IF REC.CUS NE "" THEN
        Y.CUS.MEM = REC.CUS<ST.Customer.Customer.EbCusMnemonic>
        EB.SystemTables.setRNew(EB.JBL50.CUSTOMER.MNEMONIC, Y.CUS.MEM)
        RETURN
    END
  
    EB.SystemTables.setEtext('CUSTOMER DOSE NOT EXIST')
    EB.ErrorProcessing.StoreEndError()
    
RETURN

END
