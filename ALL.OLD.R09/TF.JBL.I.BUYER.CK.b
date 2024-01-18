SUBROUTINE TF.JBL.I.BUYER.CK
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* VERSION: BD.SCT.CAPTURE,CONT.RECORD & BD.SCT.CAPTURE,CONT.AMEND
* Description : this routine check Applicant or buyer information exist or not.
* 11/29/2020 -                            Create by   - MAHMUDUR RAHMAN (UDOY),
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------

    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------
*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>

    Y.BUYER.ID = EB.SystemTables.getRNew(SCT.APPLICANT.CUSTNO)
    Y.BUYER.NAME = EB.SystemTables.getRNew(SCT.BUYER.NAME)

RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    IF Y.BUYER.ID EQ "" AND Y.BUYER.NAME EQ "" THEN
        EB.SystemTables.setAf(SCT.APPLICANT.CUSTNO)
        EB.SystemTables.setEtext("Buyer Information Missing")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
*** </region>
END
