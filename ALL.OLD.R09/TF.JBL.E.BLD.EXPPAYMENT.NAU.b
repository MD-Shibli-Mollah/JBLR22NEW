SUBROUTINE TF.JBL.E.BLD.EXPPAYMENT.NAU(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: use for version wise selection.
*Subroutine Type:
*Attached To    : JBL.ENQ.EXPPAYMENT.NAU
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 11/15/2020 -                            Retrofit   - Mahmudur Rahman
*                                               FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.POS=DCOUNT(Y.FIELDS,@VM)+1
    ENQ.DATA<2,Y.POS>='LT.TF.VER.NAME'
    ENQ.DATA<3,Y.POS>='EQ'
    ENQ.DATA<4,Y.POS>='JBL.F.EXPDOCREAL JBL.I.EXPDOCREAL JBL.F.CONDOCREAL JBL.I.CONDOCREAL EXMXPYMT'
RETURN
*** </region>

END
