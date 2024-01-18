SUBROUTINE TF.JBL.E.BLD.PRD.GROUP(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.TF.LOANS
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 16/08/2021 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.FLAG = "0"
    Y.P.GROUP = "PRODUCT.GROUP"
    LOCATE Y.P.GROUP IN Y.FIELDS SETTING Y.POS THEN
        Y.GROUP.NAME=ENQ.DATA<4,Y.POS>
        IF Y.GROUP.NAME EQ "JBL.EDF.LN" OR Y.GROUP.NAME EQ "JBL.EDF.INFIN.LN" OR Y.GROUP.NAME EQ "JBL.PAD.CASH.LN" OR Y.GROUP.NAME EQ "JBL.IDBP.LN" OR Y.GROUP.NAME EQ "JBL.LTR.LN" OR Y.GROUP.NAME EQ "JBL.PACK.CR.LN" OR Y.GROUP.NAME EQ "JBL.FDBP.LN" ELSE
*EB.SystemTables.setEtext('Please select only TF loan Group')
            EB.SystemTables.setEtext('EB-PRD.GRP.ERR')
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
*** </region>

END
