SUBROUTINE CM.JBL.AA.OVERRIDE.TO.ERROR
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    :
*Attached As    :
*-----------------------------------------------------------------------------
* Modification History :
* 08/12/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_SOA.COMMON
*
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.OVERRIDE.ID.LIST = EB.OverrideProcessing.getOveOverrideId()
    Y.COUNT = DCOUNT(Y.OVERRIDE.ID.LIST,VM)
    FOR I=1 TO Y.COUNT
        IF Y.OVERRIDE.ID.LIST<1,I> = 'EXCESS.ID' THEN
            EB.SystemTables.setEtext('You have Excess over Limit')
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.OVERRIDE.ID.LIST<1,I> = 'NO.LINE' THEN
            EB.SystemTables.setEtext('NO LINE ALLOCATED')
            EB.ErrorProcessing.StoreEndError()
	END
        NEXT I
*
        Y.SOA.OVERRIDES.COUNT = DCOUNT(SOA$OVERRIDES,'"')
        IF Y.SOA.OVERRIDES.COUNT THEN
            FOR I = 2 TO Y.SOA.OVERRIDES.COUNT STEP 2
                Y.OVERRIDE.ID = FIELD(SOA$OVERRIDES,'"',I)
                IF Y.OVERRIDE.ID EQ 'NO.LINE' THEN
                    EB.SystemTables.setEtext('NO LINE ALLOCATED')
                    EB.ErrorProcessing.StoreEndError()
                END
                IF Y.OVERRIDE.ID EQ 'EXCESS.ID' THEN
                    EB.SystemTables.setEtext('You have Excess over Limit')
                    EB.ErrorProcessing.StoreEndError()
                END
            NEXT I
        END
    
        RETURN
*** </region>

    END
