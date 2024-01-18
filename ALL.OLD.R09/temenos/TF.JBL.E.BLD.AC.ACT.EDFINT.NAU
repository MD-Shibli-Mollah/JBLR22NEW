SUBROUTINE TF.JBL.E.BLD.AA.ACT.EDFINT.NAU(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.AA.ARR.ACT.EDFINT-NAU
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 16/11/2020 -                            Retrofit   - MD. SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON

*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.POS=DCOUNT(Y.FIELDS,@VM)+1
    ENQ.DATA<2,Y.POS>="PRODUCT"
    ENQ.DATA<3,Y.POS>="EQ"
    ENQ.DATA<4,Y.POS>="JBL.EDF.INFIN.COR.LN JBL.EDF.INFIN.CTT.LN JBL.EDF.INFIN.ME.LN JBL.EDF.INFIN.MCR.LN JBL.EDF.INFIN.SE.LN"
RETURN
*** </region>

END