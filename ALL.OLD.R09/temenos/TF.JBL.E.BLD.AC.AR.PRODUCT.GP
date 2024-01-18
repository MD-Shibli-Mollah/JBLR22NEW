SUBROUTINE TF.JBL.E.BLD.AC.AR.PRODUCT.GP(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.LC.BD.BTBRECORD
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 05/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.POS=DCOUNT(Y.FIELDS,@VM)+1
    ENQ.DATA<2,Y.POS>='PRODUCT.GROUP'
    ENQ.DATA<3,Y.POS>='EQ'
    ENQ.DATA<4,Y.POS>='JBL.PAD.CASH.LN JBL.EDF.LN JBL.FCAC.GRP.AC JBL.FCACTAKA.GRP.AC JBL.TFFCY.GRP.AC JBL.TFLCY.GRP.AC'
RETURN
*** </region>

END
